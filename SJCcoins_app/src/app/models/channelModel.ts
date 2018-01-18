export class ChannelModel {
  currentChannel: string = "mychannel";
  channels: Array<Object>;
  lastResult: string;
  readyToCreate:boolean;
  readyToConnect:boolean;
  isConnected:boolean;
  peers:string = "peer0.coins.sjfabric.softjourn.if.ua:7051";
}
