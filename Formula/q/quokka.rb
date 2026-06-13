class Quokka < Formula
  desc "Inspect and clean iOS and Android devices over USB"
  homepage "https://github.com/dutradotdev/quokka"
  url "https://github.com/dutradotdev/quokka/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "ea0356c1b3b85dceddec50edfde30cfe7f25fa67be2a3ecb51ed092fad770e79"
  license "MIT"
  head "https://github.com/dutradotdev/quokka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b83a7acaa3383145e1e3f188feb1e25a8c73c7b7d48501bf4102c5c8b516c3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9758654dd13f1c20f3f701c3c6bb3f81c05b26e773eb53f67de79f346341fc5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74b9e53e18d7e51ac5bbc450eaa2675bc3b7dff8f8e3dcee49d6360002cf1f5e"
    sha256 cellar: :any,                 arm64_linux:   "fa81de7bc419e81aa1024743d3926a72cab5364bdb59c283724bd7388cbd4a1e"
    sha256 cellar: :any,                 x86_64_linux:  "9877005e5acb0f7e9c7dbe52860185eea4f3443a6be0c09255731b4272dd1a85"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/quokka-cli")
  end

  test do
    assert_match "quokka #{version}", shell_output("#{bin}/quokka --version")
    assert_match "quokka #{version}", shell_output("#{bin}/qk --version")
  end
end
