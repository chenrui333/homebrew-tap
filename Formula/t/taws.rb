class Taws < Formula
  desc "Terminal-based AWS resource viewer and manager"
  homepage "https://github.com/huseyinbabal/taws"
  url "https://github.com/huseyinbabal/taws/archive/refs/tags/v1.3.0-rc.7.tar.gz"
  sha256 "c6bd15c5541a4b6a4accb780128642f0cca78c43c741adfbade48062a8f96b51"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02cbacfbc2437ec2774e89a19a90f6cfb69ef1f1351bb7a89e5cf1d343b22c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bb6645ed2bb56df323bf68514369b10bb0ff9e467bf5b1fe2769a02546295a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9969c280cc98e9c07e7072dc8845a3d29a866155c646f6a28b5d786caec9e94"
    sha256 cellar: :any,                 arm64_linux:   "53916b0b86951c3397e228410acb57494ec1e671088c883be972886464fc333e"
    sha256 cellar: :any,                 x86_64_linux:  "70237d830e349a117325d934616fc9f13cd61c6cf2bcf948451339091f84ebd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"taws", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"taws"} --version")

    output = shell_output("#{bin/"taws"} not-a-real-command 2>&1", 2)
    assert_match "unrecognized subcommand 'not-a-real-command'", output
  end
end
