export default class StatusLes {
  //
  public static readonly MENCARI_GURU = 0
  public static readonly MEMILIH_GURU = 1
  public static readonly PENDING = 2
  public static readonly BAYAR_BELUMKONFIRMASI = 3
  public static readonly SEDANG_BERLANGSUNG = 4
  public static readonly PEMBAYARANDITOLAK= 5
  public static readonly SELESAI= 6

  public static readonly MENCARI_GURU_ULANG = 7
  public static readonly DIBATALKAN = 8

  public static readonly STATUS_DATA=[
    "MENCARI_GURU",
    "MEMILIH_GURU",
    "PENDING",
    'BAYAR_BELUMKONFIRMASI',
    "SEDANG_BERLANGSUNG",
    "PEMBAYARAN_DITOLAK",
    "SELESAI",
    "MENCARI_GURU_ULANG",
    "DIBATALKAN"
  ]

  //
  // public static readonly PENDING= 0
  // public static readonly MENUNGGU_KONFIRMASI= 1
  // public static readonly MENCARI_GURU = 2 // MENCARI GURU SAMA DENGAN LES TELAH DIKONFIRMASI
  // public static  readonly MENDAPATKAN_GURU = 3 // GURU TELAH MENERIMA ORDER
  // public static readonly PEMBAYARANDITOLAK= 4
}