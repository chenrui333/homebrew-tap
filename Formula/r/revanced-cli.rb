class RevancedCli < Formula
  desc "CLI for Revanced"
  homepage "https://revanced.app/"
  url "https://github.com/ReVanced/revanced-cli/releases/download/v6.0.0/revanced-cli-6.0.0-all.jar"
  sha256 "c25549bc17d59d2eb94fa5f86e60e9b77a02772ca88f7050f8f1276f923a9958"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7afd32c7ee5e9cbf7ad9017b055fc759cbcf2a36669d0963f57e7cd49b3b28f9"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    libexec.install "revanced-cli-#{version}-all.jar" => "revanced-cli.jar"
    bin.write_jar_script libexec/"revanced-cli.jar", "revanced-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/revanced-cli --version")

    # A real patch bundle would be downloaded at test time; check the CLI's local bundle handling instead.
    (testpath/"bad.rvp").write "not a patch bundle"
    output = shell_output("#{bin}/revanced-cli list-patches -b -p #{testpath}/bad.rvp 2>&1", 1)
    assert_match "zip END header not found", output

    output = shell_output("#{bin}/revanced-cli list-patches -p #{testpath}/bad.rvp 2>&1", 2)
    assert_match "Missing required argument(s)", output
  end
end
