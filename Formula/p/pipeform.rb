# framework: bubbletea
class Pipeform < Formula
  desc "Terraform runtime TUI"
  homepage "https://github.com/magodo/pipeform"
  url "https://github.com/magodo/pipeform/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0b251f3d0d259b0e3d15b08b95567f3eef123afae9c3d0e20107cd6f08aa6278"
  license "MPL-2.0"
  head "https://github.com/magodo/pipeform.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab1b5c745a37146903953804d6971f866d72981d670854ebea3b22e8c10a0275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3b0dad0e02d0c0d4f2f52dd2d3f17e2d7f804add14f53953170f8ce03788027"
    sha256 cellar: :any_skip_relocation, ventura:       "98bd0d2bc6e1d95ad82b99818a4b9b70744e2fcad9a935afb4774af02a6ed410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9afcde06da06062190018c1fd0209e602d7e9954722e5e3d95dd3965259f72b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    stream = <<~JSON
      {"@level":"info","@message":"Terraform will perform the following actions:"}
      {"@level":"info","@message":"Plan: 1 to add, 0 to change, 0 to destroy."}
    JSON

    tee_path = testpath/"output.jsonl"
    pipe_output("#{bin}/pipeform --plain-ui --tee #{tee_path}", stream, 1)
    assert_match "Terraform will perform", tee_path.read
  end
end
