const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const MusicSuggestionsFactory = await hre.ethers.getContractFactory(
    "MusicPortal"
  );
  const MusicSuggestions = await MusicSuggestionsFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await MusicSuggestions.deployed();

  console.log("Contract deployed to:", MusicSuggestions.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    MusicSuggestions.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  await MusicSuggestions.getTotalSuggestions();

  const suggestTxn = await MusicSuggestions.suggest("Song 1");
  await suggestTxn.wait();

  const suggestTxn1 = await MusicSuggestions.suggest("Song 2");
  await suggestTxn1.wait();

  const suggestTxn2 = await MusicSuggestions.connect(randomPerson).suggest(
    "Song 3"
  );
  await suggestTxn2.wait();

  const allSuggestions = await MusicSuggestions.getAllSuggestions();
  console.log(allSuggestions);

  await MusicSuggestions.getTotalSuggestions();

  let contractBalance1 = await hre.ethers.provider.getBalance(
    MusicSuggestions.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance1)
  );
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); // exit Node process without error
  } catch (error) {
    console.log(error);
    process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
  }
  // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
};

runMain();
