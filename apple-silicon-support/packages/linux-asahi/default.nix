{ lib
, callPackage
, linuxPackagesFor
, _kernelPatches ? [ ]
}:

let
  linux-asahi-pkg = { stdenv, lib, fetchFromGitHub, buildLinux, ... } @ args:
    (buildLinux rec {
      inherit stdenv lib;

      version = "6.14.6-1-asahi";
      modDirVersion = "6.14.6-asahi";
      extraMeta.branch = "6.14";

      src = fetchFromGitHub {
        # tracking: https://github.com/AsahiLinux/linux/tree/asahi-wip (w/ fedora verification)
        owner = "AsahiLinux";
        repo = "linux";
        rev = "asahi-6.14.6-1";
        hash = "sha256-FFntR9pEva0/zsPwZHfoIPKQaTqVWqzOeiMVQYtuWmI=";
      };

      ignoreConfigErrors = true;

      kernelPatches = [
        {
          name = "coreutils-fix";
          patch = ./0001-fs-fcntl-accept-more-values-as-F_DUPFD_CLOEXEC-args.patch;
        }
        {
          name = "Asahi config";
          patch = null;
          extraStructuredConfig = with lib.kernel; {
            # Slim down common config
            STAGING = lib.mkForce no;
            MICROCODE = lib.mkForce no;
            VIRT_DRIVERS = lib.mkForce no;
            XEN = lib.mkForce unset;
            MEDIA_DIGITAL_TV_SUPPORT = lib.mkForce no;
            MEDIA_ANALOG_TV_SUPPORT = lib.mkForce no;
            CHROME_PLATFORMS = lib.mkForce no;

            # Enforced Config
            # See: https://github.com/AsahiLinux/docs/blob/28f210d1e357d649d2e60ab908714ac3cb7da538/docs/Kernel-config-notes-for-distros.md
            DRM = yes;
            RUST = yes;
            GCC_PLUGINS = unset;
            ARM64_16K_PAGES = yes;
            RUST_DEBUG_ASSERTIONS = unset;
            RUST_OVERFLOW_CHECKS = yes;
            RUST_BUILD_ASSERT_ALLOW = unset;

            UCLAMP_TASK = yes;
            UCLAMP_TASK_GROUP = yes;
            SUSPEND = yes;
            HIBERNATION = unset;
            CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = yes;
            CPU_FREQ_DEFAULT_GOV_PERFORMANCE = lib.mkForce unset;
            ENERGY_MODEL = yes;
            SERIAL_SAMSUNG = yes;
            SERIAL_SAMSUNG_CONSOLE = yes;
            REGULATOR_FIXED_VOLTAGE = yes;
            WATCHDOG_HANDLE_BOOT_ENABLED = yes;
            DRM_ASAHI_DEBUG_ALLOCATOR = unset;
            DRM_FBDEV_EMULATION = yes;
            DRM_SCHED = yes;
            DRM_VGEM = no;
            DRM_GEM_SHMEM_HELPER = yes;
            SND_SOC_CS42L83 = module;
            SND_SOC_TAS2764 = module;
            SND_SOC_TAS2770 = module;
            HID_BATTERY_STRENGTH = yes;
            HID_APPLE = module;
            HID_MAGICMOUSE = module;
            MOUSE_APPLETOUCH = module;
            INPUT_LEDS = yes;
            LEDS_PWM = yes;
            USB_XHCI_HCD = module;
            USB_DWC3 = module;
            USB_DWC3_DUAL_ROLE = yes;
            TYPEC_TPS6598X = module;
            MMC_SDHCI = module;
            MMC_SDHCI_PCI = module;
            NET_VENDOR_AQUANTIA = yes;
            AQTION = module;
            NET_VENDOR_BROADCOM = yes;
            TIGON3 = module;
            BT = module;
            BT_BREDR = yes;
            BT_RFCOMM = module;
            BT_BNEP = module;
            BT_HIDP = module;
            BT_LE = yes;
            BT_HCIUART_BCM = yes;
            CFG80211 = module;
            WLAN_VENDOR_BROADCOM = yes;
            BRCMFMAC = module;
            BRCMFMAC_PROTO_BCDC = yes;
            BRCMFMAC_PROTO_MSGBUF = yes;
            BRCMFMAC_USB = yes;
            BRCMFMAC_PCIE = yes;
            APPLE_MFI_FASTCHARGE = module;
            SND_SOC = yes;
            SND_SOC_GENERIC_DMAENGINE_PCM = module;
            SND_SOC_COMPRESS = yes;

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

            # Explicit sound overrides
            SOUND_OSS_CORE = yes;
            SOUND_OSS_CORE_PRECLAIM = yes;
            SND_PCM = yes;
            SND_DMAENGINE_PCM = module;
            SND_HWDEP = module;
            SND_SEQ_DEVICE = yes;
            SND_COMPRESS_OFFLOAD = yes;
            SND_OSSEMUL = yes;
            SND_MIXER_OSS = module;
            SND_PCM_OSS = module;
            SND_PCM_OSS_PLUGINS = yes;
            SND_PCM_TIMER = yes;
            SND_HRTIMER = yes;
            SND_DYNAMIC_MINORS = yes;
            SND_PROC_FS = yes;
            SND_VERBOSE_PROCFS = yes;
            SND_CTL_FAST_LOOKUP = yes;
            SND_CTL_INPUT_VALIDATION = yes;
            SND_UTIMER = yes;
            SND_VMASTER = yes;
            SND_SEQUENCER = yes;
            SND_SEQ_DUMMY = yes;
            SND_SEQUENCER_OSS = module;
            SND_SEQ_HRTIMER_DEFAULT = yes;
            SND_SEQ_MIDI_EVENT = module;
            SND_SEQ_MIDI = module;
            SND_SEQ_VIRMIDI = module;
            SND_MPU401_UART = module;
            SND_DRIVERS = yes;
            SND_DUMMY = module;
            SND_ALOOP = module;
            SND_VIRMIDI = module;
            SND_MTPAV = module;
            SND_SERIAL_U16550 = module;
            SND_MPU401 = module;

            # Skip some DRM modules
            DRM_RADEON = lib.mkForce no;
            DRM_AMDGPU = lib.mkForce no;
            DRM_NOUVEAU = lib.mkForce no;
            DRM_XE = lib.mkForce no;
            DRM_VKMS = lib.mkForce no;
            DRM_VMWGFX = lib.mkForce no;
            DRM_UDL = module;
            DRM_AST = lib.mkForce no;
            DRM_MGAG200 = lib.mkForce no;
            DRM_QXL = lib.mkForce no;
            # Associated unsets
            DRM_AMDGPU_CIK = lib.mkForce unset;
            DRM_AMDGPU_SI = lib.mkForce unset;
            DRM_AMDGPU_USERPTR = lib.mkForce unset;
            DRM_AMD_ACP = lib.mkForce unset;
            DRM_AMD_DC_FP = lib.mkForce unset;
            DRM_AMD_DC_SI = lib.mkForce unset;
            DRM_AMD_ISP = lib.mkForce unset;
            DRM_AMD_SECURE_DISPLAY = lib.mkForce unset;
            DRM_NOUVEAU_GSP_DEFAULT = lib.mkForce unset;
            DRM_NOUVEAU_SVM = lib.mkForce unset;
            HSA_AMD = lib.mkForce unset;

            # Skip some networking modules
            WLAN_VENDOR_INTEL = lib.mkForce no;
            WLAN_VENDOR_INTERSIL = lib.mkForce no;
            WLAN_VENDOR_MARVELL = lib.mkForce no;
            WCN36XX = lib.mkForce no;
            ATH11K = lib.mkForce no;
            ATH12K = lib.mkForce no;
            ATH5K = lib.mkForce no;
            ATH5K_PCI = lib.mkForce unset;
            ATH9K = lib.mkForce no;
            NET_VENDOR_MEDIATEK = lib.mkForce unset;

            # Skip some Crypto modules
            OCTEONTX2_AF = lib.mkForce no;
            OCTEONTX2_PF = lib.mkForce no;
            CRYPTO_DEV_MARVELL_CESA = lib.mkForce unset;

            # Explicitly disable unsupported architectures
            ARCH_ACTIONS = lib.mkForce no;
            ARCH_AIROHA = lib.mkForce no;
            ARCH_SUNXI = lib.mkForce no;
            ARCH_ALPINE = lib.mkForce no;
            ARCH_BCM = lib.mkForce no;
            ARCH_BERLIN = lib.mkForce no;
            ARCH_BITMAIN = lib.mkForce no;
            ARCH_EXYNOS = lib.mkForce no;
            ARCH_SPARX5 = lib.mkForce no;
            ARCH_K3 = lib.mkForce no;
            ARCH_LG1K = lib.mkForce no;
            ARCH_HISI = lib.mkForce no;
            ARCH_KEEMBAY = lib.mkForce no;
            ARCH_MEDIATEK = lib.mkForce no;
            ARCH_MESON = lib.mkForce no;
            ARCH_MVEBU = lib.mkForce no;
            ARCH_NXP = lib.mkForce no;
            ARCH_MA35 = lib.mkForce no;
            ARCH_NPCM = lib.mkForce no;
            ARCH_PENSANDO = lib.mkForce no;
            ARCH_QCOM = lib.mkForce no;
            ARCH_REALTEK = lib.mkForce no;
            ARCH_RENESAS = lib.mkForce no;
            ARCH_ROCKCHIP = lib.mkForce no;
            ARCH_SEATTLE = lib.mkForce no;
            ARCH_INTEL_SOCFPGA = lib.mkForce no;
            ARCH_STM32 = lib.mkForce no;
            ARCH_SYNQUACER = lib.mkForce no;
            ARCH_TEGRA = lib.mkForce no;
            ARCH_SPRD = lib.mkForce no;
            ARCH_THUNDER = lib.mkForce no;
            ARCH_THUNDER2 = lib.mkForce no;
            ARCH_UNIPHIER = lib.mkForce no;
            ARCH_VEXPRESS = lib.mkForce no;
            ARCH_VISCONTI = lib.mkForce no;
            ARCH_XGENE = lib.mkForce no;
            ARCH_ZYNQMP = lib.mkForce no;

            # IOMMU modules
            IOMMU_IOVA = yes;
            IOMMU_API = yes;
            IOMMU_SUPPORT = yes;
            IOMMU_IO_PGTABLE = yes;
            IOMMU_IO_PGTABLE_LPAE = yes;
            IOMMU_IO_PGTABLE_ARMV7S = yes;
            IOMMU_IO_PGTABLE_DART = yes;
            IOMMU_DEFAULT_DMA_STRICT = yes;
            OF_IOMMU = yes;
            IOMMU_DMA = yes;

            # Explicit custom overrides
            NVME_AUTH = lib.mkForce yes;
            HZ_1000 = yes;
            CPU_FREQ_GOV_SCHEDUTIL = yes;
            FUNCTION_ALIGNMENT_4B = yes;
          };
          features.rust = true;
        }
      ] ++ _kernelPatches;
    } // (args.argsOverride or {})).overrideAttrs (old: {
      NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -march=armv8.6-a+fp16+fp16fml+aes+sha2+sha3+bf16+i8mm+nosve+nosve2+nomemtag+nosm4+nof32mm+nof64mm";
      hardeningEnable = [ "pic" "format" "fortify" "stackprotector" ];
      hardeningDisable = [ "bindnow" "pie" "relro" ];
    });

  linux-asahi = (callPackage linux-asahi-pkg { });
in lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)

