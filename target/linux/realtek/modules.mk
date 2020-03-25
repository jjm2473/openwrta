RTK_MENU:=Realtek kernel options

define KernelPackage/rtk-emmc
  SUBMENU:=$(RTK_MENU)
  TITLE:=Realtek eMMC driver
  KCONFIG:= \
	CONFIG_MMC=y \
	CONFIG_MMC_BLOCK=y \
	CONFIG_MMC_EMBEDDED_SDIO=n \
	CONFIG_MMC_PARANOID_SD_INIT=n \
	CONFIG_MMC_RTK_EMMC=y \
	CONFIG_MMC_RTKEMMC_JIFFY_NOT_WORK_ON_1_LAYER_FPGA=n \
	CONFIG_MMC_RTK_SDMMC=y \
	CONFIG_MMC_RTK_SDMMC_DEBUG=n \
	CONFIG_MMC_SDHCI=n \
	CONFIG_MMC_SIMULATE_MAX_SPEED=n \
	CONFIG_MMC_TIFM_SD=n \

  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_realtek @DEFAULT_kmod-rtk-emmc
endef

define KernelPackage/rtk-emmc/config
	depends on !PACKAGE_kmod-rtk-nand
endef

define KernelPackage/rtk-emmc/description
  This package enables the Realtek eMMC driver.
endef

$(eval $(call KernelPackage,rtk-emmc))

define KernelPackage/rtl8169soc
  SUBMENU:=$(RTK_MENU)
  TITLE:=Realtek Gigabit Ethernet driver
  KCONFIG:= \
	CONFIG_R8169SOC=y \
	CONFIG_RTL_RX_NO_COPY=y \
	CONFIG_NET_VENDOR_REALTEK=y
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_realtek
endef

define KernelPackage/rtl8169soc/description
  This package contains the Realtek Gigibit Ethernet driver
endef

define KernelPackage/rtl8169soc/config
	depends on !PACKAGE_kmod-rtd1295hwnat
endef

$(eval $(call KernelPackage,rtl8169soc))

define KernelPackage/rtl8125
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=Realtek R8125 PCI-E 2.5 Gigabit Ethernet driver
  DEPENDS:=@TARGET_realtek @PCI_SUPPORT +kmod-mii
  KCONFIG:=CONFIG_R8125
  FILES:= #$(LINUX_DIR)/drivers/net/ethernet/realtek/r8125/r8125.ko
  AUTOLOAD:=$(call AutoProbe,r8125)
endef

define KernelPackage/rtl8125/description
  This package contains the Realtek R8125 PCI-E 2.5 Gigibit Ethernet driver
endef

$(eval $(call KernelPackage,rtl8125))

define KernelPackage/rtl8168
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=Realtek R8168 PCI-E Gigabit Ethernet driver
  DEPENDS:=@TARGET_realtek @PCI_SUPPORT +kmod-mii
  KCONFIG:=CONFIG_R8168
  FILES:= #$(LINUX_DIR)/drivers/net/ethernet/realtek/r8168/r8168.ko
  AUTOLOAD:=$(call AutoProbe,r8168)
endef

define KernelPackage/rtl8168/description
  This package contains the Realtek R8168 PCI-E Gigibit Ethernet driver
endef

$(eval $(call KernelPackage,rtl8168))

define KernelPackage/rtd1295hwnat
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=Realtek 1295 HWNAT driver
  KCONFIG:= \
	CONFIG_BRIDGE=y \
	CONFIG_NET_SCHED=y \
	CONFIG_RTD_1295_HWNAT=y \
	CONFIG_BRIDGE_IGMP_SNOOPING=y \
	CONFIG_RTD_1295_MAC0_SGMII_LINK_MON=y \
	CONFIG_RTL_HARDWARE_NAT=y \
	CONFIG_RTL_819X=y \
	CONFIG_RTL_HW_NAPT=y \
	CONFIG_RTL_LAYERED_ASIC_DRIVER=y \
	CONFIG_RTL_LAYERED_ASIC_DRIVER_L3=y \
	CONFIG_RTL_LAYERED_ASIC_DRIVER_L4=y \
	CONFIG_RTL_LAYERED_DRIVER_ACL=y \
	CONFIG_RTL_LAYERED_DRIVER_L2=y \
	CONFIG_RTL_LAYERED_DRIVER_L3=y \
	CONFIG_RTL_LAYERED_DRIVER_L4=y \
	CONFIG_RTL_LINKCHG_PROCESS=y \
	CONFIG_RTL_NETIF_MAPPING=y \
	CONFIG_RTL_PROC_DEBUG=y \
	CONFIG_RTL_FASTPATH_HWNAT_SUPPORT_KERNEL_3_X=y \
	CONFIG_RTL_LOG_DEBUG=n \
	CONFIG_RTL865X_ROMEPERF=n \
	CONFIG_RTK_VLAN_SUPPORT=n \
	CONFIG_RTL_EEE_DISABLED=n \
	CONFIG_RTL_SOCK_DEBUG=n \
	CONFIG_RTL_EXCHANGE_PORTMASK=n \
	CONFIG_RTL_INBAND_CTL_ACL=n \
	CONFIG_RTL_ETH_802DOT1X_SUPPORT=n \
	CONFIG_RTL_MULTI_LAN_DEV=y \
	CONFIG_AUTO_DHCP_CHECK=n \
	CONFIG_RTL_HW_MULTICAST_ONLY=n \
	CONFIG_RTL_HW_L2_ONLY=n \
	CONFIG_RTL_MULTIPLE_WAN=n \
	CONFIG_RTL865X_LANPORT_RESTRICTION=n \
	CONFIG_RTL_IVL_SUPPORT=y \
	CONFIG_RTL_LOCAL_PUBLIC=n \
	CONFIG_RTL_HW_DSLITE_SUPPORT=n \
	CONFIG_RTL_HW_6RD_SUPPORT=n \
	CONFIG_RTL_IPTABLES_RULE_2_ACL=n \
	CONFIG_RTL_FAST_FILTER=n \
	CONFIG_RTL_ETH_PRIV_SKB=n \
	CONFIG_RTL_EXT_PORT_SUPPORT=n \
	CONFIG_RTL_HARDWARE_IPV6_SUPPORT=n \
	CONFIG_RTL_ROMEPERF_24K=n \
	CONFIG_RTL_VLAN_PASSTHROUGH_SUPPORT=n \
	CONFIG_RTL_8211F_SUPPORT=n \
	CONFIG_RTL_8367R_SUPPORT=n \
	CONFIG_RTL_HW_QOS_SUPPORT=n
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_realtek_rtd129x 
endef

define KernelPackage/rtd1295hwnat/description
  This package contains the Realtek HW NAT Driver
endef

define KernelPackage/rtd1295hwnat/config
  if PACKAGE_kmod-rtd1295hwnat

	config KERNEL_NF_CONNTRACK
		bool
		default y

	config KERNEL_IP_NF_IPTABLES
		bool
		default n

	config KERNEL_VLAN_8021Q
		bool
		default y

	config KERNEL_RTL_IVL_SUPPORT
		bool
		default n

	config KERNEL_PPP
		bool
		default n

	config KERNEL_RTL_FAST_PPPOE
		bool
		default n

	config KERNEL_RTL_8021Q_VLAN_SUPPORT_SRC_TAG
		bool
		default n

	config KERNEL_RTL_HW_QOS_SUPPORT
		bool "Enable HW QoS support"
		select KERNEL_IP_NF_IPTABLES
		default n
		help
		  Enable HW QoS for HW NAT.

	config KERNEL_RTL_VLAN_8021Q
		bool "Enable HW VLAN support"
		select KERNEL_VLAN_8021Q
		select KERNEL_RTL_IVL_SUPPORT
		default y
		help
		  Enable HW QoS for HW NAT.

	config KERNEL_RTL_TSO
		bool "Enable HW TSO support"
		default y
		depends on !KERNEL_RTL_IPTABLES_FAST_PATH
		help
		  Enable HW TSO for HW NAT.

	config KERNEL_RTL_IPTABLES_FAST_PATH
		bool "Enable fastpath support"
		select KERNEL_NF_CONNTRACK
		select KERNEL_IP_NF_IPTABLES
		select KERNEL_PPP
		select KERNEL_RTL_FAST_PPPOE
		default n
		help
		  Enable fastpath when packets go through CPU.

	config KERNEL_RTL_WAN_MAC5
		bool "Use VLAN 100 of MAC5 as WAN port"
		select KERNEL_VLAN_8021Q
		select KERNEL_RTL_VLAN_8021Q
		default n
		help
		  Disable original WAN (MAC4) port, and use MAC5 as WAN port.
		  WAN (MAC5): eth0.100
		  LAN (MAC5): eth0.200

	config KERNEL_RTL_836X_SUPPORT
		bool "Enable RTL836X series switches support"
		default n
		help
		  Support Realtek RTL8363, RTL8367, RTL8370 series switches.

	config KERNEL_RTL_JUMBO_FRAME
		bool "Enable JUMBO frame support"
		default n
		help
		  Support Realtek RTL8363, RTL8367, RTL8370 series switches.

	config KERNEL_RTL_BR_SHORTCUT
		bool "Enable bridge shortcut"
		depends on RTL8192CD
		default n
		help
		  Enable Bridge Shortcut between WiFi and HW NAT
  endif
endef

$(eval $(call KernelPackage,rtd1295hwnat))