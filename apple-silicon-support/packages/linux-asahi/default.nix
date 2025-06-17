{ lib
, callPackage
, linuxPackagesFor
, writeText
, _kernelPatches ? [ ]
}:

let
  i = builtins.elemAt;

  # parse <OPT> [ymn]|foo style configuration as found in a patch's extraConfig
  # into a list of k, v tuples
  parseExtraConfig = config:
    let
      lines =
        builtins.filter (s: s != "") (lib.strings.splitString "\n" config);
      parseLine = line: let
        t = lib.strings.splitString " " line;
        join = l: builtins.foldl' (a: b: "${a} ${b}")
          (builtins.head l) (builtins.tail l);
        v = if (builtins.length t) > 2 then join (builtins.tail t) else (i t 1);
      in [ "CONFIG_${i t 0}" v ];
    in map parseLine lines;

  # parse <OPT>=lib.kernel.(yes|module|no)|lib.kernel.freeform "foo"
  # style configuration as found in a patch's extraStructuredConfig into
  # a list of k, v tuples
  parseExtraStructuredConfig = config: lib.attrsets.mapAttrsToList
    (k: v: [ "CONFIG_${k}" (v.tristate or v.freeform) ] ) config;

  parsePatchConfig = { extraConfig ? "", extraStructuredConfig ? {}, ... }:
    (parseExtraConfig extraConfig) ++
    (parseExtraStructuredConfig extraStructuredConfig);

  # parse CONFIG_<OPT>=[ymn]|"foo" style configuration as found in a config file
  # into a list of k, v tuples
  parseConfig = config:
    let
      parseLine = builtins.match ''(CONFIG_[[:upper:][:digit:]_]+)=(([ymn])|"([^"]*)")'';
      # get either the [ymn] option or the "foo" option; whichever matched
      t = l: let v = (i l 2); in [ (i l 0) (if v != null then v else (i l 3)) ];
      lines = lib.strings.splitString "\n" config;
    in map t (builtins.filter (l: l != null) (map parseLine lines));

  origConfigfile = ./config;

  linux-asahi-pkg = { stdenv, lib, fetchFromGitHub, linuxKernel, ... } @ args:
    let
      origConfigText = builtins.readFile origConfigfile;

      # extraConfig from all patches in order
      extraConfig =
        lib.fold (patch: ex: ex ++ (parsePatchConfig patch)) [] _kernelPatches;
      # config file text for above
      extraConfigText = let
        text = k: v: if (v == "y") || (v == "m") || (v == "n")
          then "${k}=${v}" else ''${k}="${v}"'';
      in (map (t: text (i t 0) (i t 1)) extraConfig);

      # final config as a text file path
      configfile = if extraConfig == [] then origConfigfile else
        writeText "config" ''
          ${origConfigText}

          # Patches
          ${lib.strings.concatStringsSep "\n" extraConfigText}
        '';
      # final config as an attrset
      configAttrs = let
        makePair = t: lib.nameValuePair (i t 0) (i t 1);
        configList = (parseConfig origConfigText) ++ extraConfig;
      in builtins.listToAttrs (map makePair (lib.lists.reverseList configList));
    in
    (linuxKernel.manualConfig rec {
      inherit stdenv lib;

      version = "6.14.8-1-asahi";
      modDirVersion = "6.14.8-asahi";
      extraMeta.branch = "6.14";

      src = fetchFromGitHub {
        # tracking: https://github.com/AsahiLinux/linux/tree/asahi-wip (w/ fedora verification)
        owner = "AsahiLinux";
        repo = "linux";
        rev = "asahi-6.14.8-1";
        hash = "sha256-JrWVw1FiF9LYMiOPm0QI0bg/CrZAMSSVcs4AWNDIH3Q=";
      };

      kernelPatches = [
        {
          name = "Asahi config";
          patch = null;
          extraStructuredConfig = with lib.kernel; {
            # Enforced Config
            # See: https://github.com/AsahiLinux/docs/blob/28f210d1e357d649d2e60ab908714ac3cb7da538/docs/Kernel-config-notes-for-distros.md
            DRM = yes;
            RUST = yes;
            GCC_PLUGINS = unset;
            ARM64_16K_PAGES = yes;
            RUST_DEBUG_ASSERTIONS = unset;
            RUST_OVERFLOW_CHECKS = yes;
            RUST_BUILD_ASSERT_ALLOW = unset;

            # Asahi Config
            # See: https://github.com/AsahiLinux/docs/blob/28f210d1e357d649d2e60ab908714ac3cb7da538/docs/Kernel-config-notes-for-distros.md
            ARCH_APPLE = yes;
            ARM64_MEMORY_MODEL_CONTROL = yes;
            APPLE_AIC = yes;
            APPLE_WATCHDOG = yes;
            APPLE_DART = yes;
            APPLE_SART = yes;
            APPLE_PLATFORMS = yes;
            APPLE_MAILBOX = yes;
            APPLE_RTKIT = yes;
            APPLE_RTKIT_HELPER = yes;
            RUST_APPLE_RTKIT = yes;
            APPLE_SMC = yes;
            APPLE_SMC_RTKIT = yes;
            APPLE_PMGR_PWRSTATE = yes;
            APPLE_PMGR_MISC = yes;
            I2C_APPLE = yes;
            NVME_APPLE = yes;
            PCIE_APPLE = yes;
            PINCTRL_APPLE_GPIO = yes;
            PWM_APPLE = yes;
            SPI_APPLE = yes;
            SPMI_APPLE = yes;
            GPIO_MACSMC = yes;
            SENSORS_MACSMC = module;
            ARM_APPLE_SOC_CPUFREQ = yes;
            APPLE_ADMAC = yes;
            APPLE_M1_CPU_PMU = yes;
            COMMON_CLK_APPLE_NCO = yes;
            ARM_APPLE_CPUIDLE = yes;
            TOUCHSCREEN_APPLE_Z2 = module;
            INPUT_MACSMC_HID = yes;
            POWER_RESET_MACSMC = yes;
            CHARGER_MACSMC = yes;
            MFD_APPLE_SPMI_PMU = yes;
            VIDEO_APPLE_ISP = module;
            DRM_ASAHI = yes;
            DRM_ADP = module;
            DRM_APPLE = module;
            DRM_APPLE_AUDIO = yes;
            APPLE_SIO = module;
            APPLE_SEP = yes;
            APPLE_AOP = yes;
            SND_SOC_APPLE_AOP_AUDIO = module;
            SND_SOC_APPLE_MACAUDIO = module;
            SND_SOC_APPLE_MCA = module;
            SND_SOC_CS42L84 = module;
            SPI_HID_APPLE_OF = yes;
            HID_DOCKCHANNEL = yes;
            BT_HCIBCM4377 = module;
            RTC_DRV_MACSMC = yes;
            APPLE_DOCKCHANNEL = yes;
            PHY_APPLE_ATC = module;
            PHY_APPLE_DPTX = module;
            NVMEM_SPMI_MFD = yes;
            MUX_APPLE_DPXBAR = module;
            NVMEM_APPLE_EFUSES = yes;
            IIO_AOP_SENSOR_LAS = module;
            IIO_AOP_SENSOR_ALS = module;

            # Explicit overrides (from Alarm)
            # See: https://github.com/asahi-alarm/PKGBUILDs/blob/c392eb8337788892ec67ac34b4bc842880d4fecd/linux-asahi/config
            CPUFREQ_DT = yes;
            CPUFREQ_DT_PLATDEV = yes;
            RUST_DRM_SCHED = yes;
            RUST_DRM_GEM_SHMEM_HELPER = yes;
            RUST_DRM_GPUVM = yes;
            DRM_VIRTIO_GPU = module;
            DRM_VIRTIO_GPU_KMS = yes;
            DRM_PANEL = yes;
            DRM_ACCEL = yes;

            # Explicit custom overrides
            NVME_AUTH = lib.mkForce yes;
            HZ_1000 = yes;
            CPU_FREQ_GOV_SCHEDUTIL = yes;
            FUNCTION_ALIGNMENT_4B = yes;
          };
          features.rust = true;
        }
      ] ++ _kernelPatches;

      inherit configfile;
      config = configAttrs;
    } // (args.argsOverride or {})).overrideAttrs (old: {
      NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -march=armv8.6-a+fp16+fp16fml+aes+sha2+sha3+bf16+i8mm+nosve+nosve2+nomemtag+nosm4+nof32mm+nof64mm";
      hardeningEnable = [ "pic" "format" "fortify" "stackprotector" ];
      hardeningDisable = [ "bindnow" "pie" "relro" ];
    });

  linux-asahi = (callPackage linux-asahi-pkg { });
in lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)

