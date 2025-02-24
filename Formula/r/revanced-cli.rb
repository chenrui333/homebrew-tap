class RevancedCli < Formula
  desc "CLI for Revanced"
  homepage "https://revanced.app/"
  url "https://github.com/ReVanced/revanced-cli/releases/download/v5.0.0/revanced-cli-5.0.0-all.jar"
  sha256 "2b1c5d303c9b181120bb63b4c28cc50ccb33203cf8947add390d900f9fe7f2d8"
  license "MIT"

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
