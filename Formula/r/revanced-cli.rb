class RevancedCli < Formula
  desc "CLI for Revanced"
  homepage "https://revanced.app/"
  url "https://github.com/ReVanced/revanced-cli/releases/download/v5.0.1/revanced-cli-5.0.1-all.jar"
  sha256 "b6af8349600f56ea51d96d49aa4d2f288e28c79cd649349ba70c8b72ce045daf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04f5c7934aeaf0d12cec69a5b1e58bdd573aa60d824b24930e6c94eab68c1b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308c8edc7ec3baea133c362b398b11548f93273fd958223e8d19302cc10e0759"
    sha256 cellar: :any_skip_relocation, ventura:       "b1e9643c91647aa1290bee4c52043b7fd7f1bdd9f4cf099646d06eba616771a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e192f5b75885f485d37e1f8cff2aeaa435314b9e8e87c55200b0a48d1d5bbdb2"
  end

  depends_on "openjdk"

  def install
    libexec.install "revanced-cli-5.0.0-all.jar" => "revanced-cli.jar"
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
