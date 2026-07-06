class Rinsefm < Formula
  desc "Stream Rinse FM (or any Icecast/Shoutcast URL) in your terminal with a live audio spectrum visualizer and now-playing metadata."
  homepage "https://github.com/keenanjohnson/rinse-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.1/rinsefm-aarch64-apple-darwin.tar.xz"
      sha256 "ac9af68359538be9a3ec6d206a25047e889c0ea572dee7f0c35553b3081997e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.1/rinsefm-x86_64-apple-darwin.tar.xz"
      sha256 "20a8dc7a5db12c161fe1d3bac80b26893d94f94967af2bc4bfc81498e6c64fc1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.1/rinsefm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c1e9923ab259b63bb65f7c43a1f7fb1690392d860b63f3d4b27e92d3496ce7b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenanjohnson/rinse-cli/releases/download/v0.1.1/rinsefm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7663a11a010869f3f4617b9a4d2f416e109aa619acac93a0c66ba3ca61b7dfe3"
    end
  end
  license "MIT"
  depends_on "ffmpeg"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "rinsefm" if OS.mac? && Hardware::CPU.arm?
    bin.install "rinsefm" if OS.mac? && Hardware::CPU.intel?
    bin.install "rinsefm" if OS.linux? && Hardware::CPU.arm?
    bin.install "rinsefm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
