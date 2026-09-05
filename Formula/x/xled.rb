class Xled < Formula
  desc "Transform tabular data using regular expressions"
  homepage "https://github.com/excelano/xled"
  url "https://github.com/excelano/xled/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "5ad0e96f48cc5b56afb2957698073c89af9a75438acdeac8ce6aa8e36e28779d"
  license "MIT"
  head "https://github.com/excelano/xled.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xled --version")
    (testpath/"input.csv").write("name\nold\n")
    assert_equal "name\nnew\n", shell_output("#{bin}/xled '[name] s/old/new/' #{testpath}/input.csv")
  end
end
