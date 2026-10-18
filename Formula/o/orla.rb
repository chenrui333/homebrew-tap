class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "fa1a98bfbbf48a09b55b32a65c9789a6c30ac61f516ca3309d1511bece793a42"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44aacdfe4349293913a497d4259c0d2f32238c18f8ed806179fd9ccf356a9b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7519f2665fa37aca84c74a8dfec7d3443426f559d36da5c65def0044f740e466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d202c9f0e9bfbaca72ba17011cf27c02de41091d9831a3aa0910c8f5d318fe57"
    sha256 cellar: :any,                 x86_64_linux:  "605c2265227270e78184eb5ef6e99072d4a6c3052d50de0ed624a1c6027b174e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    require "open3"

    output, status = Open3.capture2e(bin/"orla", "serve", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
