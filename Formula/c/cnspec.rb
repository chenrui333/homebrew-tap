class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.26.0.tar.gz"
  sha256 "339d9670209424934aa6012b52191576d84901d4b68d5b44dcb10c7aaa689a2c"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "071ae5f90b998e1e455ba3d7bb2068cbb1a3bfe2cfea7906ff855b525d7981a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "453ce25a1f6f04f011b01b26945bd6ee1dae46838af8ccf4fa1016d6b613d481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7d489b5bfa80ae6420b895bc93958bdf69c14ebf57f2917a5c14fbc37b3d0d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1787a0739cfc678cb58ee503965c1760cc8027e1a7a455ca0cdb71b1c640b2"
    sha256 cellar: :any,                 x86_64_linux:  "d1b29cad4904bb009e306b489f863894d8126e512ea165944a80aac85421133a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
