class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "772b6cbb2c61cdc312977476fa04b08f52d688650dc52dd726d90ffec6512ff5"
  # Fair Core License, Version 1.0, with a future MIT license.
  license :cannot_represent
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4adf5b3050d4996af068e42a902ada600a230abf664ada8469d7232d19834c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0750e474e2d66fbe5e78b1f54305035b24ee3cb184a762860cbaa798b1460a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521effa8c28f63023b4c4b579fb64fa07eb885448f45b4d4e3c9e6f48330d3d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2ca48af5785274ace7c30799a821eb55c6e6d110cca870db86cbf533391ed13"
    sha256 cellar: :any,                 x86_64_linux:  "97a3ad460646ea7a833d0f67ce2a71e6359f83d650da99b4c1e900ebac96cf7e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/flipt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flipt --version")

    cfg = testpath/"config.yml"
    system bin/"flipt", "config", "init", "--force", "--config", cfg
    assert_match "storage:\n  default:\n    backend:\n      type: memory", cfg.read
  end
end
