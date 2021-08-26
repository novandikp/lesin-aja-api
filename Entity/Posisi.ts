export class Posisi {
    public static readonly ADMIN = 0
    public static readonly GURU = 1
    public static readonly WALI = 2
    public static readonly TAMU = 3
    public static readonly ROLE = ["Admin", "Guru", "Wali"]

    public static getPosisi(posisi:number){
        return this.ROLE[posisi];
    }
}