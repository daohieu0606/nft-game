/** Connect to Moralis server */
const serverUrl = "https://9pahilwouybl.usemoralis.com:2053/server";
const appId = "2Gv1uDCXoElW5qnEbbUBxaDuVS7IxzZsjSyzm2Px";
Moralis.start({ serverUrl, appId });

const CONTRACT_ADDRESS = "0x2B3B0480Eb36691E83f180B11C3EFD6adC45D76e";

let user = null;
let web3 = null;
let contract = null;

/** Add from here down */
async function login() {
    user = Moralis.User.current();
    if (!user) {
        try {
            user = await Moralis.authenticate({ signingMessage: "Login successful!" })
            console.log(user)
            console.log(user.get('ethAddress'))

            connectToContract();
        } catch (error) {
            console.log(error)
        }
    }
}

async function connectToContract() {
    console.log("connectting");

    await Moralis.enableWeb3();
    web3 = new window.Web3(Moralis.provider);

    let abi = await getAbi();
    contract = new web3.eth.Contract(abi, CONTRACT_ADDRESS, user);

    //TODO: remove hardcode
    document.getElementById("btnLogin").style.visibility = "hidden";
    document.getElementById("txtMessage").style.visibility = "visible";
    document.getElementById("txtMessage").innerText = "Dang nhap thanh cong";
}

async function logOut() {
    await Moralis.User.logOut();
    console.log("logged out");
}

function getAbi() {
    return new Promise((res) => {
        $.getJSON("Token.json", ((json) => {
            res(json.abi);
        }))
    });
}

async function getContractBalance() {
    let data = await contract.methods.getContractBalance().call({ from: ethereum.selectedAddress });
    console.log(data);
    document.getElementById("txtContractBalance").innerText = data;

}

async function getWalletBalance() {
    let data = await contract.methods.getWalletBalance().call({ from: ethereum.selectedAddress });
    console.log(data);
    document.getElementById("txtWalletBalance").innerText = data;
}


document.getElementById("btnLogin").onclick = login;

//TODO: hardcode
logOut();