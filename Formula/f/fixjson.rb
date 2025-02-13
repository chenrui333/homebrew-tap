class Fixjson < Formula
  desc "JSON Fixer for Humans using (relaxed) JSON5"
  homepage "https://github.com/rhysd/fixjson"
  url "https://registry.npmjs.org/fixjson/-/fixjson-1.1.2.tgz"
  sha256 "28bcae94ecfbe7495f778066216946fd1858c1ff612981f4f3d6fa12a884c879"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/fixjson"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fixjson --version")

    (testpath/"test.json").write <<~JSON
      {
        "name": "John Doe",
        "age": 30,
        "city": "New York"
      }
    JSON

    expected_output = <<~JSON
      {
        "name": "John Doe",
        "age": 30,
        "city": "New York"
      }
    JSON

    assert_equal expected_output, shell_output("#{bin}/fixjson test.json")
  end
end
