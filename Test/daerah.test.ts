
import 'mocha';
import { expect ,use,request} from "chai"
import chaiHttp from "chai-http"
import app from "../build"

use(chaiHttp)


const agent = request.agent(app)

const ROUTE= "/daerah"
describe('Ambil Data Provinsi',
  () => {
    it('should array of province', async () => {
      const result = await  agent.get(`${ROUTE}/provinsi`)
      expect(result.body.data).to.be.an("array")
    });
});

describe('Ambil Data Kota',
  () => {
    it('should array of city', async () => {
      const result = await  agent.get(`${ROUTE}/kota/11`)
      expect(result.body.data).to.be.an("array")
    });
});

describe('Ambil Data Kecamatan',
  () => {
    it('should array of city', async () => {
      const result = await  agent.get(`${ROUTE}/kecamatan/1101`)
      expect(result.body.data).to.be.an("array")
    });
});

describe('Ambil Data Desa',
  () => {
    it('should array of city', async () => {
      const result = await  agent.get(`${ROUTE}/desa/1101010`)
      expect(result.body.data).to.be.an("array")
    });
  });