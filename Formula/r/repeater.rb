class Repeater < Formula
  desc "Spaced repetition for the terminal"
  homepage "https://github.com/shaankhosla/repeater"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "fd66bcb2c74c596b133b80b5a136adb6c1ffd241543766cfdbf404f75e110c23"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ef0aa4c672a7a3e02f995c1fb6b82de27b404a9244eaf4049c1a565fd51c29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e5be71f526fc7ee653451dba6021b59e3e93e7452a921b8f6381976fbfeaf05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "025e5d9a4007f61ab589c4e62e1bd410ff439d8e1415d19ed599ab3b381a744f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47a20627f756b23a53cac9ab2393eb98eb1db7dfb6fcedffed4db52ec6d93aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4548e5a05481f15540a66f68574b7bc3a903502edd70edf96f7d933105d138ea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"cards.md").write <<~MARKDOWN
      Q: What does a synaptic vesicle store?
      A: Neurotransmitters awaiting release.

      ---

      C: Speech is [produced] in [Broca's] area.
    MARKDOWN

    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    output = shell_output("#{bin}/repeater check --plain #{testpath/"cards.md"}")
    assert_match "Collection Summary", output
    assert_match "Cards found:", output
    assert_match "2 cards", output

    data_dir = if OS.mac?
      testpath/"Library/Application Support/repeater"
    else
      testpath/".local/share/repeater"
    end
    assert_path_exists data_dir/"cards.db"
  end
end
