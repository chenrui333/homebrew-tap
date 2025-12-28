class Scrt < Formula
  desc "Secret manager for developers, sysadmins, and devops"
  homepage "https://scrt.run/"
  url "https://github.com/loderunner/scrt/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "72ac4c594e8c89b43d679118d571f2726a86628b324b33486fba4331b1dc39de"
  license "Apache-2.0"
  head "https://github.com/loderunner/scrt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f4fb4673c0c4b3b4e57ebc20e0799d5457eee94ec10bd450604f289134c7f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f4fb4673c0c4b3b4e57ebc20e0799d5457eee94ec10bd450604f289134c7f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f4fb4673c0c4b3b4e57ebc20e0799d5457eee94ec10bd450604f289134c7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d1076aec4994a7b1e5bdee1f2e96061fac61b76f69bd56ccf36485086c190a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e456d55146aa5b86ea1d15d8122391beacd136419f2c1c58395b76d2930310"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    # upstream bug report, https://github.com/loderunner/scrt/issues/1048
    # generate_completions_from_executable(bin/"scrt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrt --version")

    output = shell_output("#{bin}/scrt init --storage=local --password=p4ssw0rd --local-path=store.scrt")
    assert_match "store initialized", output
    assert_path_exists testpath/"store.scrt"
  end
end
