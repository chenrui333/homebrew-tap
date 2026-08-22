class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.38.tar.gz"
  sha256 "4550d20c926acc67c1750938a7be5e2e7005ad04e66afecfe694926024c0ff52"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be392db1f0e36effc70ae927359a0e5e19d5064227fd5083dbc3af1cf2d390e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc10a2f288c461389f9827ddeabf67f4583ce608f5644eb28e71f9237bb29d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a1162a29947f8a3d6019de2b54a4e5ecfa172f3a60786fa25dc7f8c531dae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c14298450251465670df8c7533ec142fd2c8dde343077be8cf1c52ad7a550a"
    sha256 cellar: :any,                 x86_64_linux:  "05743a05508e57340b286501ac5739c0ddac948103cda7d5ea09e01ac3b98cc2"
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
