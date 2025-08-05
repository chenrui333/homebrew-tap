class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "0582dce8a5f241f7cce78be04fcee51cc5e2c175df2ff524147018f755ccd1f6"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd389fbd44f78af6c7bb9128f242cb6000e18612d197947a7849b5b2e8a7f50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99727d35605d3bb42cb089183847708db7bb09cb09b81d680c5134c5a0a1cad2"
    sha256 cellar: :any_skip_relocation, ventura:       "fd522539b8281b016dede754e9168132c2bb4ce321feca886929867c7513b00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909f3173bebba9297386cb06b76b484bb79acee30f779f2eb051d59f2cb847a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
