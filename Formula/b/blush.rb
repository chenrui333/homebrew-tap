class Blush < Formula
  desc "Grep with colours"
  homepage "https://github.com/arsham/blush"
  url "https://github.com/arsham/blush/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6db6b033bb5d4c4ac350b36b82d79447d5b91509db3a5eceb72ecb9484495e54"
  license "MIT"
  head "https://github.com/arsham/blush.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    pipe_output("#{bin}/blush -r test", "brew test\n", 0)
  end
end
