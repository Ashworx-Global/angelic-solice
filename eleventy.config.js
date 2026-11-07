export default function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy("site/assets");

  return {
    pathPrefix: "/angelic-solice/",
    dir: {
      input: "site",
      output: "_site",
      includes: "_includes",
      data: "_data"
    }
  };
}
