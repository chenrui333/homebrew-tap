class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "984d2097529ca9cdb24c6553cf55e1001275864462dd06a8de4f338c339a0fff"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
