class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "2600226b12cbe8a6e9bf5b8f8de2a2c34a04886fef2283a1465ee1ac0f6f35cb"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffcbef6aa952bb9c387f9c9f197ddcbda43befe94a021117f662d6c15b13b13a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c24112a14f9bd664401ad8e461b9340bd2637a3c244fbf828d32c9deeb6978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75b726b6b8c6a36df7c72ee89a113f160e697e6d408c76c436b9742950ceec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e32d7fc5368b7fdb60e249b069151cb38a866dd2d9067ed5b6503f0d5069146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb4d28b55a3781cbb58b2d6889136bfff98cb95d18f20c4caa2d933f0a19f89"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
