class Cgpu < Formula
  desc "CLI enabling free cloud GPU access in your terminal for learning CUDA"
  homepage "https://github.com/RohanAdwankar/cgpu"
  url "https://registry.npmjs.org/cgpu/-/cgpu-0.1.4.tgz"
  sha256 "8035b028b1ea508082d32af11d8de6d9aad44535d1d8bb57f9339e8446c24581"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "263ecf4905432f974fd3bc793802730166fb4bac086d366643d2399d336954db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"cgpu", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
