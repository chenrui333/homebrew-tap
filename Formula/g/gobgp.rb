class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "552324ec3f7d55a005f8c5231b207d13f08b8d8d7fe31085d236bf174b7bad29"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59b8116e4b14e0674954acdded854ca6fc1cb4a3aa37bf60610bb884bc8dffcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b94e56a1ed993189bffc620d2f041b74b9dc4066569e3a6f76309dbce39f73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa279fb3d21b5e37a11ccb27aa68b34d0708feba0ef9773d094262c969f9823"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeaf706ae8a873f424d9ec3683258e25e9f39a637344329e30efaaeeba760b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b31d501aba52ddb8f8505a3735f723444acab6908ef76aaff26cfe82b23064"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gobgp"

    # `context deadline exceeded` error when generating completions
    # generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match "connect: connection refused", shell_output("#{bin}/gobgp neighbor 2>&1", 1)
  end
end
