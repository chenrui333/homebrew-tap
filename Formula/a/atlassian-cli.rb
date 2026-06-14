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

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f3d2fc8231d8ed47b439e1540ae989ceaac1904f0259be01e995c6af272d88c0"
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
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"acli", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "Invalid action", output
  end
end
