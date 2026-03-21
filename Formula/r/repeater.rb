class Repeater < Formula
  desc "Spaced repetition for the terminal"
  homepage "https://github.com/shaankhosla/repeater"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "fd66bcb2c74c596b133b80b5a136adb6c1ffd241543766cfdbf404f75e110c23"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

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
