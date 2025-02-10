class Hclq < Formula
  desc "Command-line processor for HashiCorp config files, like sed for HCL"
  homepage "https://github.com/mattolenik/hclq"
  url "https://github.com/mattolenik/hclq/archive/5b31af0dc21001c2ac770c1bea142b0e2ca0ef56.tar.gz"
  version "0.5.3"
  sha256 "d9f1fcf3e282fcceef978754fe16118c31eeb5350294f312b45182cb75967883"
  license "Unlicense"
  head "https://github.com/mattolenik/hclq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "630b2e30736fa59136be44ece3159a475798da30bd33411935a3083d96deda74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e04975185b939d924fdf67e1348820ae4d0d1d9df81af1ab615f215025c963f7"
    sha256 cellar: :any_skip_relocation, ventura:       "88c51e77d890f910dd7b4cb883c6d31eb9c50c03441c26d5d895501a09f61f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b23edaa21b122a4d6e9c257418ed88206a2adb34a67057d5875e6ca42ac12a"
  end

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
