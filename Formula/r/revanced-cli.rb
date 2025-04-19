class RevancedCli < Formula
  desc "CLI for Revanced"
  homepage "https://revanced.app/"
  url "https://github.com/ReVanced/revanced-cli/releases/download/v5.0.1/revanced-cli-5.0.1-all.jar"
  sha256 "b6af8349600f56ea51d96d49aa4d2f288e28c79cd649349ba70c8b72ce045daf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9ac4805e3d33efc5b31612ec5334dd4f0707480d71d9db3ea3695d1912ce55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f7a67ec3dd3ca7ff4b65eb519619162a28917768671365f03c264e9fd7ba9f6"
    sha256 cellar: :any_skip_relocation, ventura:       "da6f819f45b115e1cdc5f4124c546aa1d2e15629ec021fad3ed556e952aa2f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b6bc3e3453b44c0a055c76f7e6095fe92baa3cf2277d3f7f47a2df6277818ae"
  end

  depends_on "openjdk"

  def install
    libexec.install "revanced-cli-#{version}-all.jar" => "revanced-cli.jar"
    bin.write_jar_script libexec/"revanced-cli.jar", "revanced-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/revanced-cli --version")

    resource "patches_rvp" do
      url "https://github.com/ReVanced/revanced-patches/releases/download/v5.13.0-dev.11/patches-5.13.0-dev.11.rvp"
      sha256 "e162eacc07587336848fdfee949ba5941d0e939448d83a40b467ce826b54cea7"
    end

    testpath.install resource("patches_rvp")
    output = shell_output("#{bin}/revanced-cli list-patches patches-5.13.0-dev.11.rvp")
    assert_match "Index: 203\nName: Unlock premium\nDescription: null\nEnabled: true", output
  end
end
