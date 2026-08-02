class Hazelnut < Formula
  desc "Terminal-based automated file organizer"
  homepage "https://github.com/ricardodantas/hazelnut"
  url "https://github.com/ricardodantas/hazelnut/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4543797443d49889c4cf48e5a207bc84155da78a5f88ad133d52e908514fa092"
  license "GPL-3.0-or-later"
  head "https://github.com/ricardodantas/hazelnut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64b49dc2dc5bf8206503a6a09b6333f9e5097558d1c4d8d222aea7dd0d8dc6f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0280b18a0b81a0dc51953766d6093069d4c5183bb2fd61fc3b73ab683862f5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a295c1c0925bfc42badb89f585e866c99222b85ea18711a0cf6004aed0246d13"
    sha256 cellar: :any,                 arm64_linux:   "9c4eea378b047b4b2e29c44e49c96c05ce1ce0a28b00ab3eaa4ed99d007e7e67"
    sha256 cellar: :any,                 x86_64_linux:  "e551f18d28923948c03b0fa067b0ffd1651f8672268c401d60b63f4b49da005c"
  end

  depends_on "rust" => :build

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
