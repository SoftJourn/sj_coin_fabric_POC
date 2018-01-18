import { Injectable } from '@angular/core';
import {DataService} from "./data.service";
import {
  Http,
  Response,
  RequestOptions,
  Headers
} from '@angular/http';
import { environment } from '../../environments/environment';

@Injectable()
export class ChaincodeService {

  constructor(private http: Http, private data:DataService) { }

  deployChaincode(formData:string){
    let headers: Headers = new Headers();
    headers.append('Content-Type', 'application/json');
    headers.append('Authorization', this.data.user.token);

    let opts: RequestOptions = new RequestOptions();
    opts.headers = headers;

    let dataObject = Object(formData);
    dataObject.peers = environment.peers

    let url = environment.apiUrl + 'chaincodes';

    this.http.post(url, JSON.stringify(dataObject), opts)
      .subscribe((res: Response) => {
        console.log(res);
        this.data.chaincode.lastResult = res.text();
        // this.data.chaincode.chaincodeName = dataObject.chaincodeName.trim();
        // this.data.chaincode.chaincodePath = dataObject.chaincodePath.trim();
        // this.data.chaincode.chaincodeVersion = dataObject.chaincodeVersion.trim();
        // this.data.chaincode.chaincodeArgs = dataObject.chaincodeArgs.split(", ");
        console.log(this.data.chaincode.chaincodeArgs);
      });
  }

  initializeChaincode() {
    let headers: Headers = new Headers();
    headers.append('Content-Type', 'application/json');
    headers.append('Authorization', this.data.user.token);

    let opts: RequestOptions = new RequestOptions();
    opts.headers = headers;

    let dataObject = {
      peers: environment.peers,
      chaincodeName: this.data.chaincode.chaincodeName,
      chaincodeVersion: this.data.chaincode.chaincodeVersion,
      functionName: "init",
      args: this.data.chaincode.chaincodeArgs.split(", "),
      channel: this.data.channel.currentChannel
    }

    let url = environment.apiUrl + 'channels/' + this.data.channel.currentChannel + '/chaincodes';

    this.data.chaincode.lastResult = "Initializing...";

    console.log(JSON.stringify(dataObject));

    this.http.post(url, JSON.stringify(dataObject), opts)
      .subscribe((res: Response) => {
        console.log("Initialize Response: ");
        console.log(res);
        this.data.chaincode.lastResult = res.text();
      });
  }

  upgradeChaincode() {
    let headers: Headers = new Headers();
    headers.append('Content-Type', 'application/json');
    headers.append('Authorization', this.data.user.token);

    let opts: RequestOptions = new RequestOptions();
    opts.headers = headers;

    let dataObject = {
      peers: environment.peers,
      chaincodeName: this.data.chaincode.chaincodeName,
      chaincodeVersion: this.data.chaincode.chaincodeVersion,
      functionName: "init",
      args: this.data.chaincode.chaincodeArgs.split(", "),
      channel: this.data.channel.currentChannel
    }

    let url = environment.apiUrl + 'channels/' + this.data.channel.currentChannel + '/chaincodesUpgrade';

    this.data.chaincode.lastResult = "Upgrading...";

    this.http.post(url, JSON.stringify(dataObject), opts)
      .subscribe((res: Response) => {
        console.log(res);
        this.data.chaincode.lastResult = res.text();
      });
  }

  invokeChaincode(formData:string) {
    let headers: Headers = new Headers();
    headers.append('Content-Type', 'application/json');
    headers.append('Authorization', this.data.user.token);

    console.log(this.data.user.username);
    console.log(this.data.user.orgName);

    let opts: RequestOptions = new RequestOptions();
    opts.headers = headers;

    let dataObject = Object(formData);

    let url = environment.apiUrl + 'channels/' + this.data.channel.currentChannel + '/chaincodes/' + this.data.chaincode.chaincodeName;

    this.data.chaincode.lastResult = "Invoking...";

    console.log(formData);

    this.http.post(url, dataObject.chaincodeInvokeArgs, opts)
      .subscribe((res: Response) => {
        console.log(res);
        this.data.chaincode.lastResult = res.text();
      });
  }

}
