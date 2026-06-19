class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "86d72e76a193fbf4019d81d231528a4b412ad7b800f0dbda3a640c60cbd68465"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58542832a44c1886099a72662d82b814b77431c9e2fc50df585c7b24b1ad9710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "670b687f60880ed2120d76e9a3958c7f5ac6311ccc1721a5681d526ca00466e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e97b66af26dff9012dc46f17f9667c2957daa08d07e62b212cc5f6ecf844a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5818b9482c5b878b12ba8e07cbe2b15bffc9381a7741aa94162b8a7a516ebb71"
    sha256 cellar: :any,                 x86_64_linux:  "7d31939e855d0dd945d54a3e58af82b8054f7a6aa4948fe1db4050f56d9c4393"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cpg"

    generate_completions_from_executable(bin/"cpg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpg --version")
  end
end
