class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.9-jovermier.tar.gz"
  version "1.29.9-jovermier"
  sha256 "c95df107ce96962294d737d45960b514a3c4fcacf5cf82ff94aab413456daed7"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7cc5e4104b684248570cde5fe7d87bbf89132b30f234ec06d21561cc833fa54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ec47f6068d24f2dd3aad4314e3bf5fc343b765249048f1617caccb5bd90d37b"
    sha256 cellar: :any_skip_relocation, ventura:       "c2e22e90fb8a9552122060e2b3cf5ca02933ebb1bc30309f2f34857c2cda6a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "218c910cfc9aedfd15ce985c6c0f10b3cd4b36a4e8e86aed5ce32df75a2585dd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
