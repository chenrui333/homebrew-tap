class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "5495a28566bca37b5779633a83d37396efa20f7094d7627c350a3f2e4d9c2155"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c71afa88d396f37694ec6b2f7d616b5c4936a64f6717e57b7f1ff1d026aad78a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d54c05d8e6cfcdec6b6727efb25cf1b5b519631f2bd22759dc9c866a79494c8"
    sha256 cellar: :any_skip_relocation, ventura:       "a5372edd6ef19b82e5559d0c0973c4a0ba2198144837eb3f4be44a1405818172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa86da210514e9b94aebaf6118fef8154b05c528225a131971df52ed2e566fb"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
