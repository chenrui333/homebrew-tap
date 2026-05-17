class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "38e4bdd291853fc8e11663b8fe18620755f9ec64bfdc3c25a35ee04987b73435"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be1344641e1b8adecf77fd2f4fca65c7450f3af4a1d5a1c4468abbb5d56191ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cff993325b75480d0fc126310be591d4db9d3502ec1829577ae711a7ac921532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63d1e0639e31fd1900ff35fffc4527a6fbecf1b8a57ac2042b0755b34b13b452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b15248a1af267368700ede6680e848e6852608349957822257bfdb0543a3ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e336cfa02ed59c323d6ea0d07c02bfd32359d99a4aa5c9fca6129e821eb6e44c"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
