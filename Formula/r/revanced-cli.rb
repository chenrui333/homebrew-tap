class RevancedCli < Formula
  desc "CLI for Revanced"
  homepage "https://revanced.app/"
  url "https://github.com/ReVanced/revanced-cli/releases/download/v6.0.0/revanced-cli-6.0.0-all.jar"
  sha256 "c25549bc17d59d2eb94fa5f86e60e9b77a02772ca88f7050f8f1276f923a9958"
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
      url "https://github.com/ReVanced/revanced-patches/releases/download/v6.1.0/patches-6.1.0.rvp"
      sha256 "5ef9f18359a04c3bebd731cf6185b7171719aa64dbdfcd91e1d141371706ce92"
    end

    testpath.install resource("patches_rvp")
    output = shell_output("#{bin}/revanced-cli list-patches -b -p patches-6.1.0.rvp")
    assert_match "Index: 0", output
    assert_match "Name: Export all activities", output
  end
end
