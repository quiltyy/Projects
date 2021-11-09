const fetchData = async () => {
  const response = await axios.get("http://www.omdbapi.com/", {
    params: {
      apikey: "7ee02b09",
      s: "avengers",
    },
  });
  console.log(response.data);
};

fetchData();
