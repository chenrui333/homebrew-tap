class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.49.tar.gz"
  sha256 "ba8204e186470a086c7dfb11b3f32b7609f2fd333896e07c4ffc308a444548b9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3949f6b88e59701552a89b9fd2d4f7bb4777d021b78083a632e639afdaaaf41a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a127ee7ee90aa3b16473e34b0216eecbc0938745d6738ff77fa215723604d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "decd11eccc611fa0671379cd8328748d48099132f90f5f0b7250fa218ca03c18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d175aaf2c0e2a0ff274ffd1ba01bd4a34062005d082694bb7b231695111f6f"
    sha256 cellar: :any,                 x86_64_linux:  "560f4a3fef2632ab1c579a49ead57ce402d71c2f3672da1841ef360758978c63"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
