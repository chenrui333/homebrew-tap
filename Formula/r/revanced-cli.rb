class RevancedCli < Formula
  desc "CLI for Revanced"
  homepage "https://revanced.app/"
  url "https://github.com/ReVanced/revanced-cli/releases/download/v6.0.0/revanced-cli-6.0.0-all.jar"
  sha256 "c25549bc17d59d2eb94fa5f86e60e9b77a02772ca88f7050f8f1276f923a9958"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "10be9e8fdb56ef526c2f66ed4d3f20e6dcf7a1caf8aa26037a01c7e4a1159a3f"
  end

  depends_on "openjdk"

  def install
    libexec.install "revanced-cli-#{version}-all.jar" => "revanced-cli.jar"
    bin.write_jar_script libexec/"revanced-cli.jar", "revanced-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/revanced-cli --version")

    resource "patches_rvp" do
      url "https://github.com/ReVanced/revanced-patches/releases/download/v6.1.0/patches-6.1.0.rvp"
      sha256 "5ef9f18359a04c3bebd731cf6185b7171719aa64dbdfcd91e1d141371706ce92"
    end

    testpath.install resource("patches_rvp")
    output = shell_output("#{bin}/revanced-cli list-patches -b -p patches-6.1.0.rvp")
    assert_match "Index: 0", output
    assert_match "Name: Export all activities", output
  end
end
