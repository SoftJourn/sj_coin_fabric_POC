import { Component, OnInit } from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {DataService} from "../../services/data.service";
import {ChaincodeService} from "../../services/chaincode.service";

@Component({
  selector: 'app-chaincode',
  templateUrl: './chaincode.component.html',
  styleUrls: ['./chaincode.component.css']
})
export class ChaincodeComponent implements OnInit {

  public chaincodeVersion: string = "v0";

  // public chaincodeName: string = "coin";
  // public chaincodePath: string = "github.com/coins";
  // public chaincodeArgs: string = "9fbf3c83e42e2ce5ed7b1a8755b2b881b24871023e2c38242f78693985f30546, 100";

  public chaincodeName: string = "foundation";
  public chaincodePath: string = "github.com/foundation";
  //                   foundation name                          admin account                                                       foundation account
  public chaincodeArgs: string = "foundation, 9fbf3c83e42e2ce5ed7b1a8755b2b881b24871023e2c38242f78693985f30546, 4e923c618bac62daeab4651c8e82d9c26e674f5cb9faf9eb0ef120a8ba00cba5, " +
    // Goal Minutes Close Main [Colors]
      "500, 1000, true, coin, coin";

  public chaincodeInvokeArgs: string = '{"peers": ["localhost:7051", "localhost:7056"],"fcn":"donate","args":[ "coin", "10"]}';


  chaincodeForm: FormGroup;
  chaincodeInvokeForm: FormGroup;

  constructor(private chaincodeService: ChaincodeService, fb: FormBuilder, public data:DataService) {
    this.chaincodeForm = fb.group({
      'chaincodeName':  ['', Validators.required],
      'chaincodePath':  ['', Validators.required],
      'chaincodeVersion':  ['', Validators.required],
      'chaincodeArgs':  ['', Validators.required]
    });

    this.chaincodeInvokeForm = fb.group({
      'chaincodeInvokeArgs':  ['', Validators.required]
    });

  }

  ngOnInit() {
  }

  deployChaincode(formData:string):void {
    this.chaincodeService.deployChaincode(formData);
  }

  initializeChaincode():void {
    this.chaincodeService.initializeChaincode();
  }

  upgradeChaincode():void {
    this.chaincodeService.upgradeChaincode();
  }

  invokeChaincode(formData:string):void {
    this.chaincodeService.invokeChaincode(formData);
  }

}
