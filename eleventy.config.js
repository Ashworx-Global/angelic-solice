export default function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy("site/assets");
  eleventyConfig.ignores.add("site/README.md");

  // Prefix root-relative asset paths for GitHub Pages project sites, but leave
  // absolute URLs/data URIs unchanged so product data can safely reference either.
  eleventyConfig.addFilter("assetUrl", (value) => {
    if (!value) return "/angelic-solice/assets/images/product-placeholder.svg";
    if (/^(?:[a-z]+:)?\/\//i.test(value) || value.startsWith("data:")) return value;
    const path = value.startsWith("/") ? value : `/${value}`;
    if (path.startsWith("/angelic-solice/")) return path;
    return `/angelic-solice${path}`;
  });

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
