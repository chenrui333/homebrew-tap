class AtlassianCli < Formula
  desc "Command-line interface clients for Atlassian products and other providers"
  homepage "https://appfire.atlassian.net/wiki/spaces/ACLI/pages/60562669/Downloads"
  url "https://appfire.atlassian.net/wiki/download/attachments/60562669/acli-12.1.1-distribution.zip?version=1&modificationDate=1759175868313&cacheVersion=1&api=v2"
  sha256 "f0fd487e31a804509b1b7ec448a4f07b55a4be3dbc16021dd82506dd2cde0816"
  license :cannot_represent

  livecheck do
    url "https://appfire.atlassian.net/wiki/rest/api/content/60562669/child/attachment?limit=200"
    regex(/acli[._-]v?(\d+(?:\.\d+)+)-distribution\.zip/i)
  end

  depends_on "openjdk"

  def install
    cli_dir = buildpath/"acli-#{version}"
    cd cli_dir if cli_dir.directory?

    inreplace "acli.sh" do |s|
      s.gsub! "find \"${directory}/lib\" -name 'acli-*.jar'", "find '#{share}/lib' -name 'acli-*.jar'"
      s.gsub! "java ${settings} -jar \"${cliJar}\" \"${@:1}\"",
              "'#{Formula["openjdk"].opt_bin}/java' ${settings} -jar \"${cliJar}\" \"${@:1}\""
    end
    bin.install "acli.sh" => "acli"
    share.install "lib", "license"
  end

  test do
    assert_match "Welcome to the Appfire CLI", shell_output("#{bin}/acli --help 2>&1", 254)
  end
end
