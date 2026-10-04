class Hazelnut < Formula
  desc "Terminal-based automated file organizer"
  homepage "https://github.com/ricardodantas/hazelnut"
  url "https://github.com/ricardodantas/hazelnut/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4543797443d49889c4cf48e5a207bc84155da78a5f88ad133d52e908514fa092"
  license "GPL-3.0-or-later"
  head "https://github.com/ricardodantas/hazelnut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4c0db1c1f6f516fa662ca88f3e095ade6c3ae7738e359b2ad23de17e8766a1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb254f6f9fb905a1efc9d1f124b85cb1a84d96ed3bbc754ea4b0c56e84ac46c2"
    sha256 cellar: :any,                 arm64_linux:   "509d59a84683251529de6d0fcea80b48a289877369f7c0cbaa09e28c86481f4c"
    sha256 cellar: :any,                 x86_64_linux:  "1ae589f289cde0ca55673e1a1a33d3b4a8d4ff468dd4a487d0b58c90046c6230"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hazelnut --version")

    downloads = testpath/"Downloads"
    downloads.mkpath

    config = testpath/"config.toml"
    config.write <<~TOML
      [[watch]]
      path = "#{downloads}"
      recursive = false

      [[rule]]
      name = "pdfs"

      [rule.condition]
      extension = "pdf"

      [rule.action]
      type = "move"
      destination = "#{testpath/"PDFs"}"
    TOML

    output = shell_output("#{bin}/hazelnut check --config #{config}")
    assert_match "Config is valid", output
    assert_match "1 watch paths", output
    assert_match "1 rules", output
    assert_match "pdfs", shell_output("#{bin}/hazelnut --config #{config} list")
  end
end
