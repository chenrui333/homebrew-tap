class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "1af6cf9f4b04f3d1a75cae0269e917e833c24093e8b903bf11b4768c7410f5fc"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7840b2ba33ae18d14e4a3825dd4403750bb13cb3d6fc00b9d8ca5bc38eb5dc93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbe00adcafc33507bd2c1c14c7c45560bf76932ad0fe5d713abd225f890b9825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21f86091eec22fb82f8dd38649df766395510467cdbf35bc7c3fd073a022050a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "695ccfb1f435679ee701716532d656b2513005bce4715f230b7cac5c7ee08482"
    sha256 cellar: :any,                 x86_64_linux:  "9b00b6c4a635368baf34acf1c5fb098d89c35b92a892aaa627d94adf7bef3bc0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    require "open3"

    output, status = Open3.capture2e(bin/"orla", "serve", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
