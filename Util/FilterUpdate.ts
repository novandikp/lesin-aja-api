export default class FilterUpdate {
  constructor(public filters,public pgp) {
  }

  toPostgres() {
    this.filters =Object.entries(this.filters).reduce((a,[k,v]) => (v == null ? a : (a[k]=v, a)), {})
    const keys = Object.keys(this.filters)
    const s = keys
      .map((k) => this.pgp.as.name(k) + " = ${" + k + "}")
      .join(" , ")
      
    return this.pgp.as.format(s, this.filters)
  }
}
