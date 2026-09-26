{ ... }:

{
 #──[Crash Capture]────────────────────────────────────────────────────────
 # EFI pstore hangs mid-write during panics, blocking the auto-reboot.
 # ramoops writes crash dumps to a reserved RAM region instead; it survives
 # the warm reboot that panic=10 performs.
 # Loaded in initrd so it registers before the pstore archival service runs.
 boot.initrd.kernelModules = [ "ramoops" ];
 boot.kernelParams = [
   "memmap=8M\\\$0x50000000"          # reserve 8MB at 1.25GB for ramoops
   "ramoops.mem_address=0x50000000"
   "ramoops.mem_size=0x800000"
   "ramoops.record_size=0x100000"     # 1MB per dump, room for the full trace
   "efi_pstore.pstore_disable=1"      # hand pstore to ramoops
   # slub_debug and page_poison are slow; remove once the freezes are diagnosed
   "slub_debug=FZP"
   # Poisons freed pages and verifies on allocation; logs "pagealloc: single
   # bit error" (RAM) or "pagealloc: memory corruption" (stray write).
   # Replaces init_on_free, which zeroes but never checks.
   "page_poison=1"
 ];
}
