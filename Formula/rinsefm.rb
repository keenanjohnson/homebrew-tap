class Rinsefm < Formula
  desc "Stream Rinse FM (or any Icecast/Shoutcast URL) in your terminal with a live audio spectrum visualizer and now-playing metadata."
  homepage "https://github.com/keenanjohnson/rinse-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.0/rinsefm-aarch64-apple-darwin.tar.xz"
      sha256 "011b62b35604205acc6aecbfa2a0654740256cedd3620c22ba01664fd377eb58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.0/rinsefm-x86_64-apple-darwin.tar.xz"
      sha256 "98178f85b3363ee2a12aefc4b93d6ae619d31d8bb7b7522a2b1a64ddedc856fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.0/rinsefm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef6cb2e826bf88c904cf87ad8071c79e41f58e956d8578b027809c56121f8f26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.0/rinsefm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f3d37b497404e56849b264e685886c05648b7636d1cb8c61d5e299bfca5501f5"
    end
  end
  license "MIT"
  depends_on "ffmpeg"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rinsefm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rinsefm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rinsefm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rinsefm"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
