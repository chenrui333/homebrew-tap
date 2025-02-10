class Hclq < Formula
  desc "Command-line processor for HashiCorp config files, like sed for HCL"
  homepage "https://github.com/mattolenik/hclq"
  url "https://github.com/mattolenik/hclq/archive/5b31af0dc21001c2ac770c1bea142b0e2ca0ef56.tar.gz"
  version "0.5.3"
  sha256 "d9f1fcf3e282fcceef978754fe16118c31eeb5350294f312b45182cb75967883"
  license "Unlicense"
  head "https://github.com/mattolenik/hclq.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"test.tf").write <<~HCL
      data "foo" {
        bin = [1, 2, 3]

        bar = "foo string"
      }

      data "baz" {
        bin = [4, 5, 6]

        bar = "baz string"
      }
    HCL

    output = pipe_output("#{bin}/hclq get 'data.foo.bar'", (testpath/"test.tf").read, 0)
    assert_equal "\"foo string\"", output.chomp
  end
end
