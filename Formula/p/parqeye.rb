class Parqeye < Formula
  desc "Peek inside Parquet files right from your terminal"
  homepage "https://haloy.dev/"
  url "https://github.com/kaushiksrini/parqeye/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "67f896a9fe53a9f85022bdaf2042ae196feb784d2073df7d25eb37648d620139"
  license "MIT"
  head "https://github.com/kaushiksrini/parqeye.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parqeye --version")

    (testpath/"test.parquet").write <<~PARQUET
      PAR1
    PARQUET
    output = shell_output("#{bin}/parqeye #{testpath}/test.parquet 2>&1", 1)
    assert_match "EOF: Parquet file too small. Size is 5 but need 8", output
  end
end
